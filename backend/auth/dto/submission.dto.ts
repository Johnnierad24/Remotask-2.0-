import { IsString, IsOptional } from 'class-validator';

export class CreateSubmissionDto {
  @IsString()
  response: string;
}

export class ReviewSubmissionDto {
  @IsString()
  status: string;

  @IsOptional()
  @IsString()
  rejection_reason?: string;
}
