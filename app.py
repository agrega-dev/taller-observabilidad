from random import randint
from flask import Flask, request
import logging
import datetime
from datetime import timezone
from logging.config import dictConfig
from pythonjsonlogger import jsonlogger
from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry.instrumentation.logging import LoggingInstrumentor


##### LOG CONFIGURATION #####
class CustomJsonFormatter(jsonlogger.JsonFormatter):
    def add_fields(self, log_record, record, message_dict):
        super(CustomJsonFormatter, self).add_fields(log_record, record, message_dict)
        log_record['timestamp'] = datetime.datetime.now(timezone.utc)
        log_record['level'] = record.levelname
        # traceID=<id> is the default formated used by tempo in grafana cloud.
        log_record['traceID'] = f"traceID={record.otelTraceID}"

logger = logging.getLogger()
logger.setLevel('INFO')
logHandler = logging.StreamHandler()
formatter = CustomJsonFormatter('%(timestamp)s %(level)s %(name)s %(message)s')
logHandler.setFormatter(formatter)
logger.addHandler(logHandler)
#############################

app = Flask(__name__)
FlaskInstrumentor().instrument_app(app)
LoggingInstrumentor().instrument()

@app.route("/rolldice")
def roll_dice():
    logger.info("This is an example log message.")
    return str(do_roll())

def do_roll():
    return randint(1, 6)
