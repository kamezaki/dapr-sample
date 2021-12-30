import { createTerminus } from '@godaddy/terminus';
import bodyParser from 'body-parser';
import express, { Application, Request, Response, NextFunction } from 'express';
import http from 'http';
import os from 'os';

import log from '../commons/logging';

export default class ExpressServer {
  #app: Application
  constructor() {
    this.#app = express();
    this.#app
      .use(bodyParser.json())
      .use(this.#errorHandler);
  }

  router(routes: (app: Application) => void): ExpressServer {
    routes(this.#app);
    return this;
  }

  listen(p: number): ExpressServer {
    this.#app.set('port', p);
    const welcome = (port: number) => () => log.info(`up and running on ${os.hostname()}:${port}`);
    const server = http.createServer(this.#app).listen(p, welcome(p));
    createTerminus(server, {
      signals: ['SIGTERM', 'SIGINT'],
      onSignal: this.#onSignal,
      onShutdown: this.#onShutdown
    });
    return this;
  }

  #onSignal() {
    log.info(`terminate ${os.hostname()}:${this.#app.get('port')}`);
    return Promise.resolve();
  }

  #onShutdown() {
    log.info(`shudodown ${os.hostname()}:${this.#app.get('port')}`);
    return Promise.resolve();
  }

  #errorHandler(err: any, req: Request, res: Response, next: NextFunction) {
    if (res.headersSent) {
      return next(err);
    }
    const errors = err.errors || [{ message: err.message }]
    res.status(err.status || 500).json(errors);
  }
}
