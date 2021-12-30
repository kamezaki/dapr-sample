import express, { application, Application } from 'express';
import Server from './server/server';

import entriesRoutes from './entries/routes';

const defaultPort = 3000;
const defaultPortString = "" + defaultPort;

const routes = express.Router()
  .use('/entries', entriesRoutes);

export default new Server()
  .router((app: Application) => app.use(routes))
  .listen(parseInt(process.env.PORT?? defaultPortString  , 10) || defaultPort);