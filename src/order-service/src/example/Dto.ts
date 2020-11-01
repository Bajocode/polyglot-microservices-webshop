import {IsNumber, Length} from 'class-validator';

export class CreateExampleDto {
  @Length(5, 30)
  public title: string;

  @IsNumber()
  public age: number;
}

export class UpdateExampleDto {
  @Length(5, 30)
  public title: string;
}
