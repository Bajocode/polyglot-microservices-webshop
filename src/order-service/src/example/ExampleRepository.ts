import Example from './Example';
import HttpException from '../HttpException';
import {CreateExampleDto} from './Dto';

export default class ExampleRepository {
  private store: Example[] = [];

  public async findById(id: string): Promise<Example> {
    const example = await this.store.find((v) => v.id === id);
    if (!example) throw new HttpException(404, 'Example not found by given id');
    return example;
  }

  public async create(dto: CreateExampleDto): Promise<Example> {
    const found: Example = await this.store.find((v) => v.title === dto.title);
    if (found) throw new HttpException(409, `Exists title ${dto.title}`);
    this.store.push({...dto, id: '6c84fb90-12c4-11e1-840d-7b25c5ee775a'});
    return this.findById('6c84fb90-12c4-11e1-840d-7b25c5ee775a');
  }
}
