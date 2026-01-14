---
name: logging-monitoring
description: Set up Sentry error tracking and structured logging. Use when configuring monitoring for new projects, implementing error handling, or adding performance tracking.
---

# Logging & Monitoring Setup

## Why?
Without monitoring, production bugs are invisible. Structured logs enable debugging. Sentry catches errors before users report them.

## Project Level Requirements

- **Level 1 (Simple)**: Platform logs only (Vercel/Netlify) - Sentry NOT required
- **Level 2 (Medium)**: Sentry + Winston - REQUIRED
- **Level 3 (Complex)**: Sentry + Winston + ELK/APM - REQUIRED

## Sentry Setup

### Installation

```bash
# Backend (Node.js/NestJS/Express)
npm install @sentry/node @sentry/profiling-node

# Next.js
npm install @sentry/nextjs

# React
npm install @sentry/react
```

### Backend Configuration

```typescript
// src/config/sentry.config.ts
import * as Sentry from '@sentry/node';
import { nodeProfilingIntegration } from '@sentry/profiling-node';

export function initSentry() {
  Sentry.init({
    dsn: process.env.SENTRY_DSN,
    environment: process.env.NODE_ENV || 'development',
    tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.1 : 1.0,
    profilesSampleRate: process.env.NODE_ENV === 'production' ? 0.1 : 1.0,
    integrations: [nodeProfilingIntegration()],
    release: process.env.APP_VERSION,

    beforeSend(event) {
      // Filter sensitive data
      if (event.request?.headers) {
        delete event.request.headers['authorization'];
        delete event.request.headers['cookie'];
      }
      return event;
    },
  });
}
```

### Frontend Configuration (Next.js)

```typescript
// sentry.client.config.ts
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NEXT_PUBLIC_ENV || 'development',
  tracesSampleRate: 0.1,
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,
  integrations: [
    Sentry.replayIntegration({
      maskAllText: false,
      blockAllMedia: false,
    }),
  ],
  release: process.env.NEXT_PUBLIC_APP_VERSION,
  ignoreErrors: [
    'ResizeObserver loop limit exceeded',
    'Non-Error promise rejection captured',
  ],
});
```

### Error Capture with Context

```typescript
try {
  await processPayment(order);
} catch (error) {
  Sentry.captureException(error, {
    tags: { section: 'payment', orderId: order.id },
    user: { id: user.id, email: user.email },
    extra: { orderAmount: order.total, paymentMethod: order.paymentMethod },
  });
  throw error;
}
```

### NestJS Interceptor

```typescript
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
```

## Structured Logging (Winston)

### Configuration

```typescript
// src/config/logger.config.ts
import winston from 'winston';

const level = process.env.NODE_ENV === 'development' ? 'debug' : 'info';

export const logger = winston.createLogger({
  level,
  format: winston.format.combine(
    winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss:ms' }),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize({ all: true }),
        winston.format.printf(
          (info) => `${info.timestamp} ${info.level}: ${info.message}`
        )
      ),
    }),
    new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
    new winston.transports.File({ filename: 'logs/all.log' }),
  ],
});
```

### Usage

```typescript
// Good - structured with context
logger.info('User created', { userId: user.id, email: user.email });
logger.error('Payment failed', { error: error.message, orderId: order.id, userId: user.id });
logger.warn('Rate limit exceeded', { ip: req.ip, endpoint: req.path });

// Bad - unstructured
console.log('User created: ' + user.id);
```

### Log Levels

- **ERROR**: Critical issues needing immediate attention
- **WARN**: Abnormal but non-critical situations
- **INFO**: Important system events
- **HTTP**: HTTP requests (via middleware)
- **DEBUG**: Detailed debugging info (dev only)

## HTTP Logging Middleware

```typescript
@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    const startTime = Date.now();

    res.on('finish', () => {
      logger.http('HTTP Request', {
        method: req.method,
        url: req.url,
        statusCode: res.statusCode,
        duration: Date.now() - startTime,
        ip: req.ip,
        userAgent: req.get('user-agent'),
        userId: req.user?.id,
      });
    });

    next();
  }
}
```

## Environment Variables

```bash
# .env.example
SENTRY_DSN=https://xxxxx@o0000.ingest.sentry.io/0000
SENTRY_ORG=your-org
SENTRY_PROJECT=your-project
APP_VERSION=1.0.0
NODE_ENV=production

# Frontend
NEXT_PUBLIC_SENTRY_DSN=https://xxxxx@o0000.ingest.sentry.io/0000
NEXT_PUBLIC_ENV=production
NEXT_PUBLIC_APP_VERSION=1.0.0
```

## CI/CD Release Tracking

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

## Checklist

```
[] Sentry installed and configured?
[] DSN in environment variables?
[] Structured logger (Winston/Pino) installed?
[] HTTP logging middleware in place?
[] Error boundaries configured (frontend)?
[] Performance monitoring enabled?
[] Sensitive data filtered (passwords, tokens)?
[] Release tracking in CI/CD?
```

## Costs

**Sentry Free Tier:**
- 5,000 errors/month
- 10,000 performance units/month
- 500 replays/month

For high-traffic production: use sampling (`tracesSampleRate: 0.1`)
