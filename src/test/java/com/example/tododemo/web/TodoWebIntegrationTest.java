package com.example.tododemo.web;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class TodoWebIntegrationTest {

    @Autowired
    MockMvc mvc;

    @Test
    void addToggleAndDeleteTodo() throws Exception {
        mvc.perform(post("/todos").param("title", "Water the plants"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"));

        mvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Water the plants")));

        mvc.perform(post("/todos/1/toggle"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"));

        mvc.perform(post("/todos/1/delete"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"));

        mvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("Water the plants"))));
    }

    @Test
    void indexIncludesStylesheetLink() throws Exception {
        mvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/styles.css\"")));
    }

    @Test
    void stylesheetIsServedFromStaticResources() throws Exception {
        mvc.perform(get("/styles.css"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString(":root {")));
    }
}