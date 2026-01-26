# Etapa base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# Etapa build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copiar toda la solución al contenedor
COPY . .

# Restaurar la solución completa
RUN dotnet restore "SistemaVenta.API.sln"

# Compilar la solución completa
RUN dotnet build "SistemaVenta.API.sln" -c $BUILD_CONFIGURATION -o /app/build

# Publicar solo el proyecto API
FROM build AS publish
RUN dotnet publish "SistemaVenta.API/SistemaVenta.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Etapa final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SistemaVenta.API.dll"]
