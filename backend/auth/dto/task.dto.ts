import { IsString, IsNumber, IsInt, Min, IsOptional } from 'class-validator';

export class CreateTaskDto {
  @IsString()
  title!: string;

  @IsString()
  task_type!: string;

  @IsString()
  instructions!: string;

  @IsNumber()
  pay_per_task!: number;

  @IsInt()
  @Min(1)
  required_submissions!: number;

  @IsOptional()
  @IsString()
  status?: string;
}

export class UpdateTaskDto {
  @IsOptional()
  @IsString()
  title?: string;

  @IsOptional()
  @IsString()
  task_type?: string;

  @IsOptional()
  @IsString()
  instructions?: string;

  @IsOptional()
  @IsNumber()
  pay_per_task?: number;

  @IsOptional()
  @IsInt()
  @Min(1)
  required_submissions?: number;

  @IsOptional()
  @IsString()
  status?: string;
}
