

#include <stdio.h>
#include <ctype.h>

int current_line = 1;

enum Statetype {normal_text, string_literal, esc_char_from_string_literal, 
   char_literal, esc_char_from_char_literal, potential_comment, 
   in_comment, potential_comment_end};


/*Handling normal text, switch in case of quote, comment, print rest*/
enum Statetype handle_normal_text(int currentchar) {
   enum Statetype state;
   if (currentchar == '"') {
      state = string_literal; /*transition to string literal state*/
      putchar(toupper(currentchar)); /*print quote*/  
   } else if (currentchar == '\'') {
      state = char_literal;
      putchar(currentchar);
   } else if (currentchar == '/') {
      state = potential_comment;
   } else {
      state = normal_text;
      putchar(currentchar);
   }
   return state;
}

/*Within double quotes, switch if quote ends or escape char,  
print rest*/
enum Statetype handle_string_literal (int currentchar) {
   enum Statetype state;
   if (currentchar == '"') {
      state = normal_text; /*end of string literal, return to 
      normal text*/
      putchar(currentchar); /*print quote*/
   } else if (currentchar == '\\') {
      state = esc_char_from_char_literal;
      putchar(currentchar);
   } else {
      state = string_literal;
      putchar(currentchar); /*stay in string literal*/
   }
   return state;
}

/*Within esc char, removes power of next char, return to double quote*/
enum Statetype handle_esc_char_from_string_literal(int currentchar){
   enum Statetype state;
   state = string_literal;
   putchar(currentchar);
   return state;
}

/*Within single quote, switch if quote ends or escape char, print rest*/
enum Statetype handle_char_literal(int currentchar) {
   enum Statetype state;
   if (currentchar == '\'') {
      state = normal_text; /*end of char literal, return to normal text*/
      putchar(currentchar); /*print quote*/
   } else if (currentchar == '\\') {
      state = esc_char_from_char_literal;
      putchar(currentchar);
   } else {
      state = char_literal;
      putchar(currentchar);
   }
   return state;
}

/*Within esc char, removes power of next char, return to single quote*/
enum Statetype handle_esc_char_from_char_literal(int currentchar) {
   enum Statetype state;
   state = char_literal;
   putchar(currentchar);
   return state;
}

/*Comment might be starting, otherwise print it as normal text*/
enum Statetype handle_potential_comment(int currentchar) {
   enum Statetype state;
   if (currentchar == '"') {
      state = string_literal; /*false alarm: just a / followed by a string literal*/
      putchar(currentchar);
   } else if (currentchar == '\'') {
      state = char_literal; /*false alarm: just a / followed by a char literal*/
      putchar(currentchar);
   } else if (currentchar == '*') {
      state = in_comment;
      putchar(' ');
   } else if (currentchar == '/') {
      state = potential_comment;
      putchar(currentchar);
   } else {
      state = normal_text;
      putchar(currentchar);
   }
   return state;
}

/*In comment, don't print, look for the comment end, print spaces*/
enum Statetype handle_in_comment(int currentchar) {
   enum Statetype state;
   if (currentchar == '*') {
      state = potential_comment_end;
   } else {
      state = potential_comment;
   }
   return state;
}

/*Comment may be ending, don't print, return to normal if ended
  or return to comment state if not, print spaces*/
  enum Statetype handle_potential_comment_end(int currentchar) {
   enum Statetype state;
   if (currentchar == '*') {
      state = potential_comment_end;
   } else if (currentchar == '/') {
      state = normal_text;
   } else {
      state = in_comment;
   }
   return state;
}


int main(void){
   int currentchar;
   enum Statetype state = normal_text;
   while ((currentchar = getchar()) != EOF) {
      if (currentchar == '\n') {
         current_line ++; }
      switch (state) {
         case normal_text:
            state = handle_normal_text(currentchar);
            break;
         case string_literal:
            state = handle_string_literal(currentchar);
            break;
         case esc_char_from_string_literal:
            state = handle_esc_char_from_string_literal(currentchar);
            break;
         case char_literal:
            state = handle_char_literal(currentchar);
            break;
         case esc_char_from_char_literal:
            state = handle_esc_char_from_char_literal(currentchar);
            break;
         case potential_comment:
            state = handle_potential_comment(currentchar);
            break; 
         case in_comment:
            state = handle_in_comment(currentchar);
            break; 
         case potential_comment_end:
            state = handle_potential_comment(currentchar);
            break;  
      }
   }
   if (state == in_comment | state == potential_comment_end) {
      fprintf (stderr, "Error: line %d: unterminated comment\n",
         current_line);
      return 1;
   } else { 
      return 0;
   }  
}

   