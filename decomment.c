

#include <stdio.h>
#include <ctype.h>

/* Listing the possible states in DFA to be handled */
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
      state = normal_text; /*end of char literal, return to norm text*/
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

/* Body of program, while loop reads every char until the bottom of
the file, tracks the line number, tracks the state at end (accept or
reject) */
int main(void){
   /* Tracks the current char being fed into the program, prompting
   the state swithces */
   int currentchar;
   /* Tracks the current line, incrementing as \n encountered */
   int current_line = 1;
   /* Tracks the number of comments in an unterminated comment that
   must not be counted in the error message's final line count */
   int inner_comment_line = 0;

   enum Statetype state = normal_text;

   /* Central while loop drives the 'reading' of the file */
   while ((currentchar = getchar()) != EOF) {
      if (currentchar == '\n') {
            current_line++;
         }
         /* Transitions between states based on the read char */
      switch (state) {
         case normal_text:
            inner_comment_line = 0;
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
         if (inner_comment_line == 0) {  
            inner_comment_line = current_line;
         }
            state = handle_in_comment(currentchar);
            break; 
         case potential_comment_end:
         if (inner_comment_line == 0) { 
            inner_comment_line = current_line;
         }
            state = handle_potential_comment_end(currentchar);
            break;
      }
   }
   /* Deals with edge case: ending on potential comment,
    / not printed at end */
   if (state == potential_comment) {
      putchar('/');
   }

   /* Determines final state (accept or reject, provides error
   message with specified line number in case of rejection */
   if (state == in_comment || state == potential_comment_end) {
      /*if (currentchar == '\n') {
         inner_comment_line++; }*/
      fprintf (stderr, "Error: line %d: unterminated comment\n",
         (inner_comment_line)); 
      return 1; 
   }  
   return 0;
}



