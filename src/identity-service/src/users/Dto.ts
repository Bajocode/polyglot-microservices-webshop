import {IsString, IsEmail} from 'class-validator';
import User from './User';

export class CreateUserDto implements User {
  @IsEmail()
  public email: string;

  @IsString()
  public password: string;
}

export class UpdateUserDto implements User {
  @IsString()
  public userid: string;

  @IsEmail()
  public email: string;

  @IsString()
  public password: string;
}
