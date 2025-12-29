# Standards de Logging et Monitoring

**⚠️ RÈGLE OBLIGATOIRE : Tout projet DOIT implémenter un système de logging structuré et de monitoring avec Sentry (ou équivalent)**

## Pourquoi Cette Règle ?

1. **Visibilité** : Comprendre ce qui se passe en production en temps réel
2. **Debugging** : Identifier et corriger les bugs rapidement
3. **Alerting** : Être notifié immédiatement des erreurs critiques
4. **Performance** : Tracker les performances et détecter les régressions
5. **Observabilité** : Vue complète du système (logs, metrics, traces)

## Outils Requis par Écosystème

### JavaScript/TypeScript
- **Sentry** : Error tracking et performance monitoring
- **Winston** ou **Pino** : Logging structuré
- **OpenTelemetry** : Tracing distribué (optionnel)

### Python
- **Sentry** : Error tracking
- **Structlog** : Logging structuré
- **OpenTelemetry** : Tracing (optionnel)

### Autres
- **Go** : Sentry + Zap/Logrus
- **Java** : Sentry + SLF4J/Logback
- **Rust** : Sentry + tracing

## Setup Obligatoire pour Nouveaux Projets

**Pour TOUT nouveau projet, FULLSTACK_DEV DOIT :**

1. Installer Sentry et configurer pour l'environnement
2. Installer un logger structuré (Winston/Pino/Structlog)
3. Configurer les niveaux de log appropriés
4. Setup context enrichment (user, request, environment)
5. Configurer les alertes critiques
6. Intégrer dans la CI/CD

## Sentry - Configuration

### Installation (JavaScript/TypeScript)

```bash
npm install @sentry/node @sentry/profiling-node
# ou pour Next.js
npm install @sentry/nextjs
# ou pour React
npm install @sentry/react
```

### Backend Configuration (NestJS/Express)

```typescript
// src/config/sentry.config.ts
import * as Sentry from '@sentry/node';
import { nodeProfilingIntegration } from '@sentry/profiling-node';

export function initSentry() {
  Sentry.init({
    dsn: process.env.SENTRY_DSN,
    environment: process.env.NODE_ENV || 'development',

    // Performance Monitoring
    tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.1 : 1.0,

    // Profiling
    profilesSampleRate: process.env.NODE_ENV === 'production' ? 0.1 : 1.0,

    integrations: [
      nodeProfilingIntegration(),
    ],

    // Release tracking
    release: process.env.APP_VERSION,

    // Filter sensitive data
    beforeSend(event, hint) {
      // Remove sensitive data
      if (event.request?.headers) {
        delete event.request.headers['authorization'];
        delete event.request.headers['cookie'];
      }
      return event;
    },
  });
}

// src/main.ts
import { initSentry } from './config/sentry.config';

async function bootstrap() {
  initSentry(); // FIRST LINE

  const app = await NestFactory.create(AppModule);
  // ... rest of app setup
}
```

### Frontend Configuration (React/Next.js)

```typescript
// sentry.client.config.ts (Next.js)
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NEXT_PUBLIC_ENV || 'development',

  // Performance Monitoring
  tracesSampleRate: 0.1,

  // Session Replay
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,

  integrations: [
    Sentry.replayIntegration({
      maskAllText: false,
      blockAllMedia: false,
    }),
  ],

  // Release tracking
  release: process.env.NEXT_PUBLIC_APP_VERSION,

  // Ignore known errors
  ignoreErrors: [
    'ResizeObserver loop limit exceeded',
    'Non-Error promise rejection captured',
  ],
});
```

### Error Tracking - Usage

```typescript
// Backend - Automatic error capture via middleware
@Injectable()
export class SentryInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      catchError((error) => {
        Sentry.captureException(error, {
          contexts: {
            http: {
              method: context.switchToHttp().getRequest().method,
              url: context.switchToHttp().getRequest().url,
            },
          },
        });
        return throwError(() => error);
      }),
    );
  }
}

// Manual error capture with context
try {
  await processPayment(order);
} catch (error) {
  Sentry.captureException(error, {
    tags: {
      section: 'payment',
      orderId: order.id,
    },
    user: {
      id: user.id,
      email: user.email,
    },
    extra: {
      orderAmount: order.total,
      paymentMethod: order.paymentMethod,
    },
  });
  throw error;
}

// Frontend - Automatic with Error Boundary
import * as Sentry from '@sentry/react';

const ErrorFallback = ({ error, resetError }) => (
  <div>
    <h2>Something went wrong</h2>
    <button onClick={resetError}>Try again</button>
  </div>
);

const App = () => (
  <Sentry.ErrorBoundary fallback={ErrorFallback}>
    <YourApp />
  </Sentry.ErrorBoundary>
);
```

### Performance Monitoring

```typescript
// Backend - Transaction tracking
import * as Sentry from '@sentry/node';

@Injectable()
export class UserService {
  async findOne(id: string): Promise<User> {
    return Sentry.startSpan(
      {
        name: 'UserService.findOne',
        op: 'db.query',
      },
      async () => {
        const user = await this.prisma.user.findUnique({ where: { id } });

        Sentry.setContext('user_query', {
          userId: id,
          found: !!user,
        });

        return user;
      }
    );
  }
}

// Frontend - Custom transactions
const handleCheckout = async () => {
  const transaction = Sentry.startTransaction({
    name: 'checkout-flow',
    op: 'user-interaction',
  });

  try {
    const span1 = transaction.startChild({ op: 'validate-cart' });
    await validateCart();
    span1.finish();

    const span2 = transaction.startChild({ op: 'process-payment' });
    await processPayment();
    span2.finish();

    transaction.setStatus('ok');
  } catch (error) {
    transaction.setStatus('internal_error');
    throw error;
  } finally {
    transaction.finish();
  }
};
```

## Logging Structuré

### Winston Configuration (Backend)

```typescript
// src/config/logger.config.ts
import winston from 'winston';

const levels = {
  error: 0,
  warn: 1,
  info: 2,
  http: 3,
  debug: 4,
};

const level = () => {
  const env = process.env.NODE_ENV || 'development';
  return env === 'development' ? 'debug' : 'info';
};

const colors = {
  error: 'red',
  warn: 'yellow',
  info: 'green',
  http: 'magenta',
  debug: 'white',
};

winston.addColors(colors);

const format = winston.format.combine(
  winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss:ms' }),
  winston.format.errors({ stack: true }),
  winston.format.splat(),
  winston.format.json()
);

const transports = [
  new winston.transports.Console({
    format: winston.format.combine(
      winston.format.colorize({ all: true }),
      winston.format.printf(
        (info) => `${info.timestamp} ${info.level}: ${info.message}`
      )
    ),
  }),
  new winston.transports.File({
    filename: 'logs/error.log',
    level: 'error',
  }),
  new winston.transports.File({ filename: 'logs/all.log' }),
];

export const logger = winston.createLogger({
  level: level(),
  levels,
  format,
  transports,
});
```

### Usage des Logs

```typescript
import { logger } from './config/logger.config';

// ✅ BON : Logs structurés avec contexte
logger.info('User created', {
  userId: user.id,
  email: user.email,
  timestamp: new Date().toISOString(),
});

logger.error('Payment failed', {
  error: error.message,
  orderId: order.id,
  amount: order.total,
  userId: user.id,
});

logger.warn('Rate limit exceeded', {
  ip: req.ip,
  endpoint: req.path,
  attempts: rateLimitInfo.attempts,
});

// ❌ MAUVAIS : Logs non structurés
console.log('User created: ' + user.id);
console.error('Payment failed!');
```

### Niveaux de Log

```typescript
// ERROR : Erreurs critiques nécessitant attention immédiate
logger.error('Database connection failed', { error });

// WARN : Situations anormales mais non critiques
logger.warn('Cache miss for frequently accessed data', { key });

// INFO : Événements importants du système
logger.info('User logged in', { userId, ip });

// HTTP : Requêtes HTTP (via middleware)
logger.http('GET /api/users', { statusCode: 200, duration: 45 });

// DEBUG : Informations détaillées pour debugging (dev uniquement)
logger.debug('Processing queue item', { item, queueSize });
```

## Context Enrichment

```typescript
// Middleware pour enrichir les logs avec contexte request
@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    const startTime = Date.now();

    res.on('finish', () => {
      const duration = Date.now() - startTime;

      logger.http('HTTP Request', {
        method: req.method,
        url: req.url,
        statusCode: res.statusCode,
        duration,
        ip: req.ip,
        userAgent: req.get('user-agent'),
        userId: req.user?.id,
      });
    });

    next();
  }
}

// Sentry - User context
Sentry.setUser({
  id: user.id,
  email: user.email,
  username: user.name,
});

// Sentry - Custom context
Sentry.setContext('business', {
  plan: subscription.plan,
  isTrialing: subscription.isTrial,
});
```

## Alerting

### Sentry Alerts Configuration

```yaml
# Configuration via Sentry UI ou API
alerts:
  - name: "Critical Error Rate"
    conditions:
      - type: "event_frequency"
        value: 100
        interval: "1h"
    actions:
      - type: "slack"
        channel: "#alerts-critical"
      - type: "pagerduty"

  - name: "Performance Degradation"
    conditions:
      - type: "p95_transaction_duration"
        value: 2000 # ms
        comparison: ">"
    actions:
      - type: "slack"
        channel: "#alerts-performance"
```

## Variables d'Environnement

```bash
# .env.example
SENTRY_DSN=https://xxxxx@o0000.ingest.sentry.io/0000
SENTRY_ORG=your-org
SENTRY_PROJECT=your-project
APP_VERSION=1.0.0
NODE_ENV=production

# Frontend (.env.local)
NEXT_PUBLIC_SENTRY_DSN=https://xxxxx@o0000.ingest.sentry.io/0000
NEXT_PUBLIC_ENV=production
NEXT_PUBLIC_APP_VERSION=1.0.0
```

## Intégration CI/CD

```yaml
# .github/workflows/deploy.yml
- name: Create Sentry release
  uses: getsentry/action-release@v1
  env:
    SENTRY_AUTH_TOKEN: ${{ secrets.SENTRY_AUTH_TOKEN }}
    SENTRY_ORG: ${{ secrets.SENTRY_ORG }}
    SENTRY_PROJECT: ${{ secrets.SENTRY_PROJECT }}
  with:
    environment: production
    version: ${{ github.sha }}
    sourcemaps: ./dist
```

## Checklist Nouveau Projet

```
□ Sentry installé et configuré ?
□ DSN Sentry ajouté aux variables d'environnement ?
□ Logger structuré (Winston/Pino) installé ?
□ Middleware de logging HTTP en place ?
□ Error boundaries configurés (frontend) ?
□ Performance monitoring activé ?
□ Context enrichment implémenté (user, request) ?
□ Alertes critiques configurées ?
□ Source maps uploadés à Sentry ?
□ Release tracking configuré dans CI/CD ?
□ Logs sensibles filtrés (passwords, tokens) ?
□ Niveaux de log appropriés par environnement ?
□ Documentation des codes d'erreur créée ?
```

## Responsabilités

**ARCHITECT :**
- Vérifier présence de Sentry dans TOUT nouveau projet
- Bloquer approbation si monitoring non configuré
- Valider la stratégie de logging

**FULLSTACK_DEV :**
- Installer et configurer Sentry au démarrage
- Implémenter le logging structuré
- Enrichir les logs avec contexte pertinent
- Capturer les erreurs avec Sentry

**DEVOPS :**
- Configurer les variables d'environnement Sentry
- Setup release tracking dans CI/CD
- Configurer les alertes et intégrations
- Monitorer les logs et métriques

**REVIEWER :**
- Vérifier que les erreurs sont capturées
- Valider le niveau de détail des logs
- Vérifier qu'aucune donnée sensible n'est loggée
- S'assurer du context enrichment

## Exemples de Bonnes Pratiques

### Capture d'Erreur Complète

```typescript
// ✅ BON : Erreur avec contexte riche
async function processOrder(order: Order, user: User) {
  const transaction = Sentry.startTransaction({
    name: 'process-order',
    data: { orderId: order.id },
  });

  try {
    logger.info('Processing order', {
      orderId: order.id,
      userId: user.id,
      amount: order.total,
    });

    await validateOrder(order);
    const payment = await chargePayment(order);
    await fulfillOrder(order);

    logger.info('Order processed successfully', {
      orderId: order.id,
      paymentId: payment.id,
    });

    transaction.setStatus('ok');
  } catch (error) {
    logger.error('Order processing failed', {
      error: error.message,
      stack: error.stack,
      orderId: order.id,
      userId: user.id,
    });

    Sentry.captureException(error, {
      tags: {
        section: 'order-processing',
        orderStatus: order.status,
      },
      user: {
        id: user.id,
        email: user.email,
      },
      extra: {
        orderDetails: {
          id: order.id,
          total: order.total,
          items: order.items.length,
        },
      },
    });

    transaction.setStatus('internal_error');
    throw error;
  } finally {
    transaction.finish();
  }
}

// ❌ MAUVAIS : Pas de contexte
try {
  await processOrder(order, user);
} catch (error) {
  console.error(error);
}
```

### Filtrage de Données Sensibles

```typescript
// ✅ BON : Filtrer les données sensibles
Sentry.init({
  beforeSend(event) {
    // Remove passwords
    if (event.request?.data) {
      const data = event.request.data;
      if (typeof data === 'object') {
        delete data.password;
        delete data.token;
        delete data.apiKey;
      }
    }

    // Remove auth headers
    if (event.request?.headers) {
      delete event.request.headers['authorization'];
      delete event.request.headers['cookie'];
    }

    return event;
  },
});

// Logger configuration
logger.info('User login attempt', {
  email: user.email,
  // ❌ NE JAMAIS logger password, token, etc.
});
```

## Coûts et Quotas

**Sentry propose un plan gratuit** :
- 5,000 errors/month
- 10,000 performance units/month
- 500 replays/month

Pour les projets en production avec trafic élevé :
- Utiliser sampling (`tracesSampleRate: 0.1`)
- Filtrer les erreurs non critiques
- Upgrade au plan payant si nécessaire

## Alternatives à Sentry

Si Sentry n'est pas possible (budget, etc.) :

- **Bugsnag** : Alternative similaire
- **Rollbar** : Error tracking
- **LogRocket** : Session replay + error tracking
- **Self-hosted** : GlitchTip (Sentry open-source fork)
- **ELK Stack** : Elasticsearch + Logstash + Kibana (plus complexe)

**⚠️ L'absence de monitoring n'est PAS une option.**

## Pourquoi C'est Obligatoire

1. **Bugs en production** : Impossible de débugger sans logs/monitoring
2. **Expérience utilisateur** : Détecter et corriger rapidement les problèmes
3. **Compliance** : Certaines régulations requièrent du logging
4. **Performance** : Identifier les bottlenecks
5. **Sécurité** : Détecter les tentatives d'attaque
6. **Visibilité** : Comprendre l'usage réel de l'application

**⚠️ Aucun projet ne peut être déployé en production sans monitoring/logging configuré.**
