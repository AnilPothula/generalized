#!/usr/bin/env python
import pika

credentials = pika.PlainCredentials('admin', 'qweqwe')
parameters = pika.ConnectionParameters(host='35.153.204.148',
                                       port=5672,
                                       virtual_host='/',
                                       credentials=credentials,
                                       ssl_options=None)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()

channel.queue_declare(queue='hello', durable=True)

channel.basic_publish(
    exchange='',
    routing_key='hello',
    body='Hello World!',
    properties=pika.BasicProperties(delivery_mode=2,
    ))
print(" [x] Sent 'Hello World!'")
connection.close()