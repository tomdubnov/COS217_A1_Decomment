

#include <stdio.h>
#include <ctype.h>


enum Statetype {normal_text, 
   string_literal, 
   esc_char_from_string_literal, 
   char_literal, 
   esc_char_from_char_literal, 
   potential_comment, 
   in_comment, 
   potential_comment_end};


/*Handling normal text, switch in case of quote, comment, print rest*/
enum Statetype handle_normal_text(int currentchar) {
   enum Statetype state;
   if (currentchar == '"') {
      putchar(currentchar); /*print quote*/  
      state = string_literal; /*transition to string literal state*/
   } else if (currentchar == '\'') {
      putchar(currentchar);
      state = char_literal;
   } else if (currentchar == '/') {
      state = potential_comment;
   } else {
      putchar(currentchar);
      state = normal_text;
   }
   return state;
}

/*Within double quotes, switch if quote ends or escape char,  
print rest*/
enum Statetype handle_string_literal (int currentchar) {
   enum Statetype state;
   if (currentchar == '"') {
      putchar(currentchar); /*print quote*/
      state = normal_text; /*end of string literal, return to 
      normal text*/
   } else if (currentchar == '\\') {
      putchar(currentchar);
      state = esc_char_from_string_literal;
   } else {
      putchar(currentchar); /*stay in string literal*/
      state = string_literal;
   }
   return state;
}

/*Within esc char, removes power of next char, return to double quote*/
enum Statetype handle_esc_char_from_string_literal(int currentchar){
   enum Statetype state;
   putchar(currentchar);
   state = string_literal;
   return state;
}

/*Within single quote, switch if quote ends or escape char, print rest*/
enum Statetype handle_char_literal(int currentchar) {
   enum Statetype state;
   if (currentchar == '\'') {
      putchar(currentchar); /*print quote*/
      state = normal_text; /*end of char literal, return to normal text*/
   } else if (currentchar == '\\') {
      putchar(currentchar);
      state = esc_char_from_char_literal;
   } else {
      putchar(currentchar);
      state = char_literal;
   }
   return state;
}

/*Within esc char, removes power of next char, return to single quote*/
enum Statetype handle_esc_char_from_char_literal(int currentchar) {
   enum Statetype state;
   putchar(currentchar);
   state = char_literal;
   return state;
}

/*Comment might be starting, otherwise print it as normal text*/
enum Statetype handle_potential_comment(int currentchar) {
   enum Statetype state;
   if (currentchar == '"') {
      putchar('/');
      putchar(currentchar);
      state = string_literal; /*false alarm: just a / 
      followed by a string literal*/
   } else if (currentchar == '\'') {
      putchar('/');
      putchar(currentchar);
      state = char_literal; /*false alarm: just a / 
      followed by a char literal*/
   } else if (currentchar == '*') {
      putchar(' ');
      state = in_comment;
   } else if (currentchar == '/') {
      putchar('/');
      state = potential_comment;
   } else {
      putchar('/');
      putchar(currentchar);
      state = normal_text;
   }
   return state;
}

/*In comment, don't print, look for the comment end, print spaces*/
enum Statetype handle_in_comment(int currentchar) {
   enum Statetype state;
   if (currentchar == '\n') {
      putchar(currentchar);
      state = in_comment;
   } else if (currentchar == '*') {
      state = potential_comment_end;
   } else {
      state = in_comment;
   }

   return state;
}

/*Comment may be ending, don't print, return to normal if ended
  or return to comment state if not, print spaces*/
  enum Statetype handle_potential_comment_end(int currentchar) {
   enum Statetype state;
   if (currentchar == '\n') {
      putchar(currentchar);
      state = in_comment;
   } else if (currentchar == '/') {
      state = normal_text;
   } else if (currentchar == '*') {
      state = potential_comment_end;
   } else {
      state = in_comment;
   }
   return state;
}


int main(void){
   int currentchar;
   int current_line = 1;
   int inner_comment_line = 0;
   enum Statetype state = normal_text;

   while ((currentchar = getchar()) != EOF) {
      if (currentchar == '\n') {
            current_line++;
         }
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
            state = handle_potential_comment_end(currentchar);
            break;
         /*case new_line:
            state = handle_new_line(currentchar);*/ 
      }
   }

   if (state == potential_comment) {
      putchar('/');
   }


   if (state == in_comment || state == potential_comment_end) {
      if (currentchar == '\n') {
         inner_comment_line++;
      fprintf (stderr, "Error: line %d: unterminated comment\n",
         current_line - inner_comment_line); } 
      return 1; 
   }  
   return 0;
}



