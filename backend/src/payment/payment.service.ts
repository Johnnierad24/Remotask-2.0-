import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';

@Injectable()
export class PaymentService {
  private baseUrl = 'https://api.flutterwave.com/v3';
  private secretKey: string;
  private publicKey: string;

  constructor(private configService: ConfigService) {
    this.secretKey = this.configService.get<string>('FLUTTERWAVE_SECRET_KEY') || '';
    this.publicKey = this.configService.get<string>('FLUTTERWAVE_PUBLIC_KEY') || '';
  }

  /**
   * Initialize payment for client deposit
   */
  async initializePayment(data: {
    amount: number;
    email: string;
    name: string;
    tx_ref: string;
    redirect_url?: string;
  }) {
    try {
      const response = await axios.post(
        `${this.baseUrl}/payments`,
        {
          tx_ref: data.tx_ref,
          amount: data.amount,
          currency: 'USD',
          redirect_url: data.redirect_url || `${this.configService.get('FRONTEND_URL')}/payment/callback`,
          payment_options: 'card,mobilemoney,ussd',
          customer: {
            email: data.email,
            name: data.name,
          },
          customizations: {
            title: 'CANARY Wallet Deposit',
            description: 'Add funds to your wallet',
            logo: 'https://your-logo-url.com/logo.png',
          },
        },
        {
          headers: {
            Authorization: `Bearer ${this.secretKey}`,
            'Content-Type': 'application/json',
          },
        },
      );

      return {
        status: 'success',
        data: response.data.data,
        link: response.data.data.link,
      };
    } catch (error: any) {
      throw new Error(`Payment initialization failed: ${error.response?.data?.message || error.message}`);
    }
  }

  /**
   * Verify payment transaction
   */
  async verifyPayment(transactionId: string) {
    try {
      const response = await axios.get(
        `${this.baseUrl}/transactions/${transactionId}/verify`,
        {
          headers: {
            Authorization: `Bearer ${this.secretKey}`,
          },
        },
      );

      return {
        status: response.data.status,
        data: response.data.data,
      };
    } catch (error: any) {
      throw new Error(`Payment verification failed: ${error.response?.data?.message || error.message}`);
    }
  }

  /**
   * Process payout to worker (Bank transfer or Mobile Money)
   */
  async processPayout(data: {
    amount: number;
    account_bank: string; // Bank code
    account_number: string;
    currency?: string;
    narration?: string;
    reference: string;
    beneficiary_name?: string;
  }) {
    try {
      const response = await axios.post(
        `${this.baseUrl}/transfers`,
        {
          account_bank: data.account_bank,
          account_number: data.account_number,
          amount: data.amount,
          currency: data.currency || 'USD',
          narration: data.narration || 'CANARY payout',
          reference: data.reference,
          callback_url: `${this.configService.get('BACKEND_URL')}/api/v1/payments/payout-callback`,
          debit_currency: data.currency || 'USD',
        },
        {
          headers: {
            Authorization: `Bearer ${this.secretKey}`,
            'Content-Type': 'application/json',
          },
        },
      );

      return {
        status: 'success',
        data: response.data.data,
      };
    } catch (error: any) {
      throw new Error(`Payout failed: ${error.response?.data?.message || error.message}`);
    }
  }

  /**
   * Process Mobile Money payout (for M-Pesa, Airtel Money, MTN MoMo)
   */
  async processMobileMoneyPayout(data: {
    amount: number;
    phone_number: string;
    currency?: string;
    narration?: string;
    reference: string;
  }) {
    try {
      const response = await axios.post(
        `${this.baseUrl}/transfers`,
        {
          account_bank: 'MPS', // Mobile Money code (varies by country)
          account_number: data.phone_number,
          amount: data.amount,
          currency: data.currency || 'KES', // Kenya Shillings for M-Pesa
          narration: data.narration || 'CANARY payout',
          reference: data.reference,
          callback_url: `${this.configService.get('BACKEND_URL')}/api/v1/payments/payout-callback`,
        },
        {
          headers: {
            Authorization: `Bearer ${this.secretKey}`,
            'Content-Type': 'application/json',
          },
        },
      );

      return {
        status: 'success',
        data: response.data.data,
      };
    } catch (error: any) {
      throw new Error(`Mobile Money payout failed: ${error.response?.data?.message || error.message}`);
    }
  }

  /**
   * Get list of banks for a country (for bank transfers)
   */
  async getBanks(country: string = 'KE') {
    try {
      const response = await axios.get(
        `${this.baseUrl}/banks/${country}`,
        {
          headers: {
            Authorization: `Bearer ${this.secretKey}`,
          },
        },
      );

      return response.data.data;
    } catch (error: any) {
      throw new Error(`Failed to fetch banks: ${error.response?.data?.message || error.message}`);
    }
  }

  /**
   * Verify account number (before payout)
   */
  async verifyAccountNumber(accountNumber: string, accountBank: string) {
    try {
      const response = await axios.post(
        `${this.baseUrl}/accounts/resolve`,
        {
          account_number: accountNumber,
          account_bank: accountBank,
        },
        {
          headers: {
            Authorization: `Bearer ${this.secretKey}`,
            'Content-Type': 'application/json',
          },
        },
      );

      return {
        status: 'success',
        data: response.data.data,
      };
    } catch (error: any) {
      throw new Error(`Account verification failed: ${error.response?.data?.message || error.message}`);
    }
  }
}
