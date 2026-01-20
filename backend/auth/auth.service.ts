import { Injectable, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import * as bcrypt from 'bcryptjs';

@Injectable()
export class AuthService {
	constructor(private prisma: PrismaService, private jwtService: JwtService) {}

	async register(registerDto: RegisterDto) {
		const { email, password } = registerDto;
		const existingUser = await this.prisma.user.findUnique({ where: { email } });
		if (existingUser) {
			throw new BadRequestException('Email already in use');
		}
		const hashedPassword = await bcrypt.hash(password, 10);
		// Default role can be 'USER' or 'WORKER' as needed
		const user = await this.prisma.user.create({
			data: {
				email,
				password_hash: hashedPassword,
				role: 'USER',
			},
		});
		const payload = { sub: user.id, email: user.email, role: user.role };
		const token = this.jwtService.sign(payload);
		return { message: 'Registration successful', token, user: { id: user.id, email: user.email, role: user.role } };
	}

	async login(loginDto: LoginDto) {
		const { email, password } = loginDto;
		const user = await this.prisma.user.findUnique({ where: { email } });
		if (!user || !(await bcrypt.compare(password, user.password_hash))) {
			throw new BadRequestException('Invalid credentials');
		}
		const payload = { sub: user.id, email: user.email, role: user.role };
		const token = this.jwtService.sign(payload);
		return { message: 'Login successful', token, user: { id: user.id, email: user.email, role: user.role } };
	}
}
}
