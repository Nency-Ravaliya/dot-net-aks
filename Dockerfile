# Use the official .NET Core SDK image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env

# Set the working directory in the container
WORKDIR /app

# Copy the solution file and restore dependencies
COPY MyConsoleApp.sln ./
RUN dotnet restore

# Copy the project files and build the application
COPY MyConsoleApp/ ./MyConsoleApp/
RUN dotnet build MyConsoleApp -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:5.0
WORKDIR /app
COPY --from=build-env /app/MyConsoleApp/out ./
ENTRYPOINT ["dotnet", "MyConsoleApp.dll"]
