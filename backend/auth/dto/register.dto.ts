import { IsEmail, IsNotEmpty, MinLength, IsIn } from 'class-validator';

export class RegisterDto {
  @IsNotEmpty()
  full_name!: string;

  @IsEmail()
  email!: string;

  @IsNotEmpty()
  @MinLength(6)
  password!: string;

  @IsNotEmpty()
  @IsIn(['worker', 'client'])
  user_type!: string;
}
