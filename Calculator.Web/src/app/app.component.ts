import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { CalculatorService } from './services/calculator.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="container">
      <h1>Calculator Web Client</h1>
      <div class="calculator-card">
        <h2>gRPC Calculator</h2>
        
        <div class="form-group">
          <label for="number1">First Number:</label>
          <input 
            type="number" 
            id="number1" 
            [(ngModel)]="number1" 
            placeholder="Enter first number"
            [disabled]="loading">
        </div>

        <div class="form-group">
          <label for="number2">Second Number:</label>
          <input 
            type="number" 
            id="number2" 
            [(ngModel)]="number2" 
            placeholder="Enter second number"
            [disabled]="loading">
        </div>

        <div class="operations">
          <button 
            class="btn btn-primary" 
            (click)="performOperation('add')"
            [disabled]="loading || !isValidInput()">
            Add (+)
          </button>
          <button 
            class="btn btn-primary" 
            (click)="performOperation('subtract')"
            [disabled]="loading || !isValidInput()">
            Subtract (-)
          </button>
          <button 
            class="btn btn-primary" 
            (click)="performOperation('multiply')"
            [disabled]="loading || !isValidInput()">
            Multiply (×)
          </button>
          <button 
            class="btn btn-primary" 
            (click)="performOperation('divide')"
            [disabled]="loading || !isValidInput()">
            Divide (÷)
          </button>
        </div>

        <div class="operations" style="margin-top: 10px;">
          <button 
            class="btn btn-secondary" 
            (click)="clearFields()"
            [disabled]="loading">
            Clear
          </button>
        </div>

        <div *ngIf="loading" class="loading">
          Calculating...
        </div>

        <div *ngIf="error" class="error">
          {{ error }}
        </div>

        <div *ngIf="result !== null && !loading && !error" class="result-section">
          <h3>Result:</h3>
          <div class="result-value">{{ result }}</div>
        </div>
      </div>
    </div>
  `,
  styleUrls: []
})
export class AppComponent {
  title = 'Calculator Web Client';
  number1: number | null = null;
  number2: number | null = null;
  result: number | null = null;
  loading = false;
  error: string | null = null;

  constructor(private calculatorService: CalculatorService) {}

  isValidInput(): boolean {
    return this.number1 !== null && this.number2 !== null && 
           !isNaN(this.number1) && !isNaN(this.number2);
  }

  performOperation(operation: 'add' | 'subtract' | 'multiply' | 'divide'): void {
    if (!this.isValidInput() || this.number1 === null || this.number2 === null) {
      this.error = 'Please enter valid numbers for both fields';
      return;
    }

    this.loading = true;
    this.error = null;
    this.result = null;

    let operationObservable;
    
    switch (operation) {
      case 'add':
        operationObservable = this.calculatorService.add(this.number1, this.number2);
        break;
      case 'subtract':
        operationObservable = this.calculatorService.subtract(this.number1, this.number2);
        break;
      case 'multiply':
        operationObservable = this.calculatorService.multiply(this.number1, this.number2);
        break;
      case 'divide':
        operationObservable = this.calculatorService.divide(this.number1, this.number2);
        break;
    }

    operationObservable.subscribe({
      next: (result) => {
        this.result = result;
        this.loading = false;
      },
      error: (error) => {
        this.error = error.message || 'An error occurred while performing the calculation';
        this.loading = false;
      }
    });
  }

  clearFields(): void {
    this.number1 = null;
    this.number2 = null;
    this.result = null;
    this.error = null;
  }
}