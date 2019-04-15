package io.github.logtube.logtubeddemo;

import io.github.logtube.http.LogtubeHttpFilter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class LogtubedDemoApplication {

    @Bean
    public FilterRegistrationBean<LogtubeHttpFilter> logtubeAcessFilter() {
        FilterRegistrationBean<LogtubeHttpFilter> registration = new FilterRegistrationBean<>();
        registration.setFilter(new LogtubeHttpFilter());
        registration.addUrlPatterns("/*");
        return registration;
    }

    public static void main(String[] args) {
        SpringApplication.run(LogtubedDemoApplication.class, args);
    }

}
