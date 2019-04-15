package io.github.logtube.logtubeddemo.controllers;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Date;

@RestController
public class WelcomeController {

    static final Logger LOGGER = LoggerFactory.getLogger(WelcomeController.class);

    @GetMapping("/")
    public String index() {
        LOGGER.trace("trace test {}", new Date());
        LOGGER.debug("debug test {}", new Date());
        LOGGER.info("info test {}", new Date());
        LOGGER.warn("warn test {}", new Date());
        LOGGER.error("error test", new Exception());
        return "Index";
    }

}
