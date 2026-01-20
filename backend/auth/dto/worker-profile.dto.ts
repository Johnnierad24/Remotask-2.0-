import { IsString, IsArray, IsOptional, IsInt, Min, Max, IsNumber } from 'class-validator';

export class CreateWorkerProfileDto {
  @IsArray()
  @IsString({ each: true })
  skills: string[];

  @IsInt()
  @Min(1)
  level: number;

  @IsOptional()
  @IsNumber()
  rating?: number;

  @IsInt()
  @Min(0)
  completed_tasks: number;
}

export class UpdateWorkerProfileDto {
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  skills?: string[];

  @IsOptional()
  @IsInt()
  @Min(1)
  level?: number;

  @IsOptional()
  @IsNumber()
  rating?: number;

  @IsOptional()
  @IsInt()
  @Min(0)
  completed_tasks?: number;
}
