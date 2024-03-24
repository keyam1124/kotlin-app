package zid.ktapp

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class KtAppApplication

fun main(args: Array<String>) {
	runApplication<KtAppApplication>(*args)
}
