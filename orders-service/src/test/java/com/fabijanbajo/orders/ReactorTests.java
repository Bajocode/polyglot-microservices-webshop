package com.fabijanbajo.orders;
import org.junit.Test;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

public class ReactorTests {
	@Test
	public void TestFlux() {
		List<Integer> list = new ArrayList<>();
		Flux.just(1,2,3,4)
			.filter(n -> n * 2 == 4)
			.map(n -> n-1)
			.log()
			.subscribe(n -> list.add(n));
		assertThat(list).containsExactly(1);
	}
}
