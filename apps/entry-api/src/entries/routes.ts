import express, {Request, Response} from 'express';

export default express.Router()
  .use('/', (req: Request, res: Response) => {
    res.send({
      messege: 'ok'
    })
  });