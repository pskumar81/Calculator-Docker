using Calculator.Client.Services;
using Calculator.Client.Services.Interfaces;
using Grpc.Net.Client;

namespace Calculator.Client.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddCalculatorClient(this IServiceCollection services, string serverUrl)
    {
        services.AddSingleton(GrpcChannel.ForAddress(serverUrl));
        services.AddScoped<ICalculatorClientService, CalculatorClientService>();
        
        return services;
    }
}
