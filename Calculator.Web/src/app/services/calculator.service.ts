import { Injectable } from '@angular/core';
import { Observable, from } from 'rxjs';

export interface CalculateRequest {
  number1: number;
  number2: number;
}

export interface CalculateReply {
  result: number;
}

@Injectable({
  providedIn: 'root'
})
export class CalculatorService {
  private readonly serverUrl = 'http://localhost:5001';

  constructor() {}

  // Mock gRPC calls using HTTP fetch for now
  // In a real implementation, these would use the generated gRPC-Web client

  add(number1: number, number2: number): Observable<number> {
    return from(this.performHttpRequest('Add', { number1, number2 }));
  }

  subtract(number1: number, number2: number): Observable<number> {
    return from(this.performHttpRequest('Subtract', { number1, number2 }));
  }

  multiply(number1: number, number2: number): Observable<number> {
    return from(this.performHttpRequest('Multiply', { number1, number2 }));
  }

  divide(number1: number, number2: number): Observable<number> {
    return from(this.performHttpRequest('Divide', { number1, number2 }));
  }

  private async performHttpRequest(operation: string, request: CalculateRequest): Promise<number> {
    try {
      // For demonstration purposes, using HTTP POST to simulate gRPC calls
      // In a real gRPC-Web implementation, this would use the generated client
      const response = await fetch(`${this.serverUrl}/calculator.CalculatorService/${operation}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/grpc-web+proto',
          'X-Grpc-Web': '1'
        },
        body: JSON.stringify(request)
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      return result.result;
    } catch (error) {
      // Fallback to mock calculations for demonstration
      console.warn('gRPC call failed, using mock calculation:', error);
      return this.mockCalculation(operation, request.number1, request.number2);
    }
  }

  private mockCalculation(operation: string, num1: number, num2: number): number {
    switch (operation) {
      case 'Add':
        return num1 + num2;
      case 'Subtract':
        return num1 - num2;
      case 'Multiply':
        return num1 * num2;
      case 'Divide':
        if (num2 === 0) {
          throw new Error('Cannot divide by zero');
        }
        return num1 / num2;
      default:
        throw new Error('Unknown operation');
    }
  }
}