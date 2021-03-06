// import * as bcrypt from 'bcrypt';
import * as request from 'supertest';
import App from '../app';
import AuthRoute from '../auth/AuthRoute';
import {CreateUserDto} from '../users/Dto';
import HttpException from '../HttpException';
import {TokenData} from '../interfaces/auth.interface';
import AuthService from '../services/auth.service';

afterAll(async () => {
  await new Promise((resolve) => setTimeout(() => resolve(), 500));
});

describe('Auth', () => {
  describe('[POST] /register', () => {
    it('response should have the Create userData', () => {
      const userData: CreateUserDto = {
        email: 'lkm@gmail.com',
        password: 'q1w2e3r4',
      };
      const authRoute = new AuthRoute();
      const app = new App([authRoute]);

      return request(app.getServer())
          .post(`${authRoute.path}/register`)
          .send(userData);
    });
  });

  describe('[POST] /login', () => {
    it('response should have the Set-Cookie header with the Authorization token', async () => {
      const userData: CreateUserDto = {
        email: 'lim@gmail.com',
        password: 'q1w2e3r4',
      };
      process.env.JWT_SECRET = 'jwt_secret';
      const authRoute = new AuthRoute();
      const app = new App([authRoute]);

      return request(app.getServer())
          .post(`${authRoute.path}/login`)
          .send(userData)
          .expect('Set-Cookie', /^Authorization=.+/);
    });
  });

  // describe('[POST] /logout', () => {
  //   it('logout Set-Cookie Authorization=; Max-age=0', () => {
  //     const authRoute = new AuthRoute();
  //     const app = new App([authRoute]);

  //     return request(app.getServer())
  //         .post(`${authRoute.path}/logout`)
  //         .expect('Set-Cookie', /^Authorization=\;/);
  //   });
  // });
  // });

  // describe('Testing AuthService', () => {
  // describe('when creating a cookie', () => {
  //   it('should return a string', () => {
  //     const tokenData: TokenData = {
  //       token: '',
  //       expiresIn: 1,
  //     };

  //     const authService = new AuthService();

  //     expect(typeof authService.createCookie(tokenData))
  //         .toEqual('string');
  //   });
  // });

  // describe('when registering a user', () => {
  //   describe('if the email is already token', () => {
  //     it('should throw an error', async () => {
  //       const userData: CreateUserDto = {
  //         email: 'lkm@gmail.com',
  //         password: 'q1w2e3r4',
  //       };

  //       const authService = new AuthService();

  //       authService.users.find = jest
  //           .fn()
  //           .mockReturnValue(Promise.resolve(userData));

  //       await expect(authService.signup(userData))
  //           .rejects
  //           .toMatchObject(new HttpException(400, `User with email ${userData.email} already exists`));
  //     });
  //   });

  //   describe('if the email is not token', () => {
  //     it('should not throw an error', async () => {
  //       const userData: CreateUserDto = {
  //         email: 'lkm@gmail.com',
  //         password: 'q1w2e3r4',
  //       };
  //       process.env.JWT_SECRET = 'jwt_secret';

  //       const authService = new AuthService();

  //       authService.users.find = jest
  //           .fn()
  //           .mockReturnValue(Promise.resolve(undefined));

  //       authService.users = jest
  //           .fn()
  //           .mockReturnValue({_id: 0, ...userData});

  //       await expect(authService.signup(userData))
  //           .resolves
  //           .toBeDefined();
  //     });
  //   });
  // });
});
