# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["SmartServe.Api/SmartServe.Api.csproj", "SmartServe.Api/"]
RUN dotnet restore "SmartServe.Api/SmartServe.Api.csproj"

COPY . .
WORKDIR "/src/SmartServe.Api"
RUN dotnet build "SmartServe.Api.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "SmartServe.Api.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000

ENTRYPOINT ["dotnet", "SmartServe.Api.dll"]

