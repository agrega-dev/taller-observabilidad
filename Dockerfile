# Builder image.
FROM python:3.10-slim-buster AS builder

# Use virtualenv to make it easier to copy the artifacts to the final image.
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip.
RUN pip install --no-cache-dir --upgrade pip~=22.2.2

# Generate instrumentation packages and append it to requirements.txt.
RUN pip install opentelemetry-distro==0.33b0
COPY requirements.txt /tmp/
RUN opentelemetry-bootstrap -a requirements >> /tmp/requirements.txt

# Install packages.
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Final image.
FROM python:3.10-slim-buster AS final

COPY --from=builder /opt/venv /opt/venv

# Create non-root user.
RUN useradd --create-home appuser
USER appuser

ENV PATH="/opt/venv/bin:$PATH"
ENV FLASK_APP "app.py"
ENV PYTHONUNBUFFERED 1
ENV PYTHONUNBUFFERED 1
ENV PORT 8000

WORKDIR /home/appuser
COPY . /home/appuser

ENTRYPOINT ["gunicorn", "app:app", "--config", "gunicorn.config.py"]
