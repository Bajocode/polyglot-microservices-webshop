package com.fabijanbajo.orders;

import java.util.concurrent.Executors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Bean;

import reactor.core.scheduler.Scheduler;
import reactor.core.scheduler.Schedulers;

@SpringBootApplication
public class OrdersApplication {
	private static final Logger LOG = LoggerFactory.getLogger(OrdersApplication.class);

	private final int poolSize;

	@Autowired
	public OrdersApplication(@Value("${spring.datasource.maximum-pool-size:10}") int poolSize) {
		this.poolSize = poolSize;
	}

	@Bean
	public Scheduler getScheduler() {
		LOG.info("New jdbc scheduler with poolsize: " + poolSize);
		return Schedulers.fromExecutor(Executors.newFixedThreadPool(poolSize));
	}

	public static void main(String[] args) {
		ConfigurableApplicationContext ctx = SpringApplication.run(OrdersApplication.class, args);
		String dbUrl = ctx.getEnvironment().getProperty("spring.datasource.url");
		LOG.info("Connected to DB: " + dbUrl);
	}

}
