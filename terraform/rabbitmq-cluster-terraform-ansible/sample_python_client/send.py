#!/usr/bin/env python
import pika

credentials = pika.PlainCredentials('admin', 'qweqwe')
parameters = pika.ConnectionParameters(host='54.88.74.180',
                                       port=5672,
                                       virtual_host='/',
                                       credentials=credentials,
                                       ssl_options=None)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()

channel.queue_declare(queue='hello')

channel.basic_publish(exchange='', routing_key='hello', body='Hello World!')
print(" [x] Sent 'Hello World!'")
connection.close()