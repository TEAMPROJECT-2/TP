package com.itwillbs.function;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import org.springframework.ui.Model;


public class FunctionClass {
   
   // íėŽėę°
   public String nowTime(String pattern) {
      return LocalDateTime.now().format(DateTimeFormatter.ofPattern(pattern));
   }
   
  
}