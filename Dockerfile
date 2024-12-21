# Use .NET 8 SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Restore and build the project
RUN dotnet restore
RUN dotnet publish -c Release -o out
# Final stage: run the application using the ASP.NET Core runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Install the New Relic agent
RUN apt-get update && apt-get install -y wget ca-certificates gnupg \
    && echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
    && wget https://download.newrelic.com/548C16BF.gpg \
    && apt-key add 548C16BF.gpg \
    && apt-get update \
    && apt-get install -y newrelic-dotnet-agent

# Enable the New Relic agent
ENV CORECLR_ENABLE_PROFILING=1 \
    CORECLR_PROFILER={36032161-FFC0-4B61-B559-F6C5D41BAE5A} \
    CORECLR_NEWRELIC_HOME=/usr/local/newrelic-dotnet-agent \
    CORECLR_PROFILER_PATH=/usr/local/newrelic-dotnet-agent/libNewRelicProfiler.so \
    NEW_RELIC_LICENSE_KEY={license_key} \
    NEW_RELIC_APP_NAME=simpleweb

WORKDIR /app
COPY --from=build /app/out .
# Expose port 80 for the application
EXPOSE 80
# Set the appication to listen on IPv4 only
ENV ASPNETCORE_URLS=http://0.0.0.0:80
# Run the application
ENTRYPOINT ["dotnet", "simpleweb.dll"]
