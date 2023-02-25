FROM nginx:alpine AS base
WORKDIR /var/www/web
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["blazordocker0.csproj", "."]
RUN dotnet restore "./blazordocker0.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "blazordocker0.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "blazordocker0.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /var/www/web
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf