from locust import *


class MyUser(HttpUser):
    wait_time = between(5, 15)

    @task(3)
    def get_products(self):
        self.client.get('/catalog/products')

    @task(6)
    def get_products(self):
        self.client.get('/catalog/products')

    wait_time = between(0.5, 10)
