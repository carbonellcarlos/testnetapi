# NuGet restore
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

COPY TestProject.Api.sln .
COPY TestProject.Api/*.csproj TestProject.Api/

RUN dotnet restore

COPY . .
WORKDIR /src/TestProject.Api
RUN dotnet publish -c Release -o /src/publish



FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/TestProject.Api/src/publish .
# ENTRYPOINT ["dotnet", "TestProject.Api.dll"]
# heroku uses the following
CMD ASPNETCORE_URLS=http://*:$PORT dotnet TestProject.Api.dll
