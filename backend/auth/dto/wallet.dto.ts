import { IsNumber, Min, IsString } from 'class-validator';

export class WalletWithdrawDto {
  @IsNumber()
  @Min(1)
  amount: number;

  @IsString()
  payment_method: string;
}
