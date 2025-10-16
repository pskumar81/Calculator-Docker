﻿using Grpc.Net.Client;
using Calculator.Client;

Console.WriteLine("Welcome to the Calculator Client!");
Console.WriteLine("Connecting to the Calculator Server...");

var serverUrl = Environment.GetEnvironmentVariable("SERVER_URL") ?? "http://localhost:5000";
using var channel = GrpcChannel.ForAddress(serverUrl);
var client = new CalculatorService.CalculatorServiceClient(channel);

while (true)
{
    Console.WriteLine("\nSelect operation:");
    Console.WriteLine("1. Add");
    Console.WriteLine("2. Subtract");
    Console.WriteLine("3. Multiply");
    Console.WriteLine("4. Divide");
    Console.WriteLine("5. Exit");
    
    var operation = Console.ReadLine();
    if (operation == "5")
        break;

    if (!new[] { "1", "2", "3", "4" }.Contains(operation))
    {
        Console.WriteLine("Invalid operation. Please select a number between 1 and 5.");
        continue;
    }

    Console.WriteLine("Enter the first number:");
    if (!double.TryParse(Console.ReadLine(), out double num1))
    {
        Console.WriteLine("Invalid input. Please enter a valid number.");
        continue;
    }

    Console.WriteLine("Enter the second number:");
    if (!double.TryParse(Console.ReadLine(), out double num2))
    {
        Console.WriteLine("Invalid input. Please enter a valid number.");
        continue;
    }

    try
    {
        var request = new CalculateRequest { Number1 = num1, Number2 = num2 };
        CalculateReply reply;
        string operationSymbol;

        switch (operation)
        {
            case "1":
                reply = await client.AddAsync(request);
                operationSymbol = "+";
                break;
            case "2":
                reply = await client.SubtractAsync(request);
                operationSymbol = "-";
                break;
            case "3":
                reply = await client.MultiplyAsync(request);
                operationSymbol = "*";
                break;
            case "4":
                reply = await client.DivideAsync(request);
                operationSymbol = "/";
                break;
            default:
                continue;
        }

        Console.WriteLine($"Result from server: {num1} {operationSymbol} {num2} = {reply.Result}");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error: {ex.Message}");
        Console.WriteLine("Make sure the server is running.");
    }
}