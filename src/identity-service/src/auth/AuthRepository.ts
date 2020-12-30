import {sign, Algorithm, SignOptions} from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import Config from '../Config';
import User from '../users/User';
import {CreateUserDto} from '../users/Dto';
import UserRepository from '../users/UserRepository';
import Token from './Token';
import HttpException from '../HttpException';

export default class AuthRepository {
  private readonly config: Config;
  private readonly userRepo: UserRepository;

  public constructor(
      config: Config,
      userRepo: UserRepository) {
    this.config = config;
    this.userRepo = userRepo;
  }

  public async register(dto: CreateUserDto): Promise<Token> {
    const digest = await bcrypt.hash(dto.password, 10);
    const user: User = await this.userRepo.create({...dto, password: digest});

    return this.signed(user);
  }


  public async login(dto: CreateUserDto): Promise<Token> {
    const user: User = await this.userRepo.readByEmail(dto.email);
    const valid = await bcrypt.compare(dto.password, user.password);

    if (!valid) throw new HttpException(409, 'Invalid password');

    return this.signed(user);
  }

  private signed(user: User): Token {
    delete user.password;
    const payload = {user};
    const expiresIn = Math.floor(Date.now() / 1000) + this.config.jwtExpSecs;
    const options: SignOptions = {
      expiresIn,
      algorithm: this.config.jwtAlgo as Algorithm,
    };

    const signed = sign(payload, this.config.jwtSecret, options);

    return {
      token: signed,
      expiry: expiresIn,
    };
  }
}
