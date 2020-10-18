import {
  IsString,
  IsDecimal,
  IsNotEmpty,
  MaxLength} from 'class-validator';

export default class CreateProductDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  public name: string;

  @IsDecimal({
    force_decimal: true,
    decimal_digits: '2',
  })
  @IsNotEmpty()
  public price: number;
}
