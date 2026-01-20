import { IsString, IsBoolean, IsOptional } from 'class-validator';

export class CreateClientProfileDto {
  @IsString()
  company_name: string;

  @IsOptional()
  @IsBoolean()
  verified?: boolean;
}

export class UpdateClientProfileDto {
  @IsOptional()
  @IsString()
  company_name?: string;

  @IsOptional()
  @IsBoolean()
  verified?: boolean;
}
