import express, {Request, Response} from 'express';
import { v4 as uuidV4 } from 'uuid';

export default express.Router()
  .use('/', (req: Request, res: Response) => {
    res.send({
      id: uuidV4()
    })
  });