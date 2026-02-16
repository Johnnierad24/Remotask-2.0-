import { Controller, Get, Post, Put, Body, Param, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { SubmissionService } from './submission.service';
import { CreateSubmissionDto, ReviewSubmissionDto } from './dto/submission.dto';

@Controller('submissions')
@UseGuards(JwtAuthGuard)
export class SubmissionController {
  constructor(private readonly submissionService: SubmissionService) {}

  @Get('task/:taskId')
  async getSubmissionsForTask(@Param('taskId') taskId: string) {
    return this.submissionService.getSubmissionsForTask(taskId);
  }

  @Post(':taskId')
  async submitTask(@Request() req: any, @Param('taskId') taskId: string, @Body() body: CreateSubmissionDto) {
    return this.submissionService.submitTask(req.user.userId, taskId, body);
  }

  @Put(':id/review')
  async reviewSubmission(@Request() req: any, @Param('id') id: string, @Body() body: ReviewSubmissionDto) {
    return this.submissionService.reviewSubmission(req.user.userId, id, body);
  }
}
