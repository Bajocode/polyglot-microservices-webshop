import {NextFunction, Request, Response} from 'express';
import {CreateExampleDto} from './Dto';
import Example from './Example';
import ExampleRepository from './ExampleRepository';

export default class ExampleHandler {
  private repo = new ExampleRepository();

  public getById = async (
      req: Request,
      res: Response,
      next: NextFunction) => {
    const id: string = String(req.params.exampleId);

    try {
      const example: Example = await this.repo.findById(id);
      res.status(200).json(example);
    } catch (err) {
      next(err);
    }
  }

  public post = async (
      req: Request,
      res: Response,
      next: NextFunction) => {
    const dto: CreateExampleDto = req.body;

    try {
      const example: Example = await this.repo.create(dto);
      res.status(201).json(example);
    } catch (err) {
      next(err);
    }
  }
}
