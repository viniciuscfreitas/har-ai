# Use python:3.13-slim as base image
FROM python:3.13-slim

# Set working directory to /src
WORKDIR /src

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the backend code into a 'backend' directory to preserve package structure
# When we run "python -m backend.main", python looks for a package named 'backend'
COPY . backend/

# Expose port (FastAPI defaults to 8000)
EXPOSE 8000

# Command to run the application
# We use -m to run as a module, allowing relative imports to work
CMD ["python", "-m", "backend.main"]
