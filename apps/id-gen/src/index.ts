import express, { Application } from 'express';
import Server from './server/server';

import idsRoutes from './ids/routes';

const defaultPort = 3100;
const defaultPortString = "" + defaultPort;

const routes = express.Router()
  .use('/ids', idsRoutes);

export default new Server()
  .router((app: Application) => app.use(routes))
  .listen(parseInt(process.env.PORT?? defaultPortString  , 10) || defaultPort);