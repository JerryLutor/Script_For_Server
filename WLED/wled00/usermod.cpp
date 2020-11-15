#include "wled.h"
#pragma once
/*
 * This v1 usermod file allows you to add own functionality to WLED more easily
 * See: https://github.com/Aircoookie/WLED/wiki/Add-own-functionality
 * EEPROM bytes 2750+ are reserved for your custom use case. (if you extend #define EEPSIZE in const.h)
 * If you just need 8 bytes, use 2551-2559 (you do not need to increase EEPSIZE)
 * 
 * Consider the v2 usermod API if you need a more advanced feature set!
 */

//Use userVar0 and userVar1 (API calls &U0=,&U1=, uint16_t)

int fadeAmount = 5;  // how many points to fade the Neopixel with each step
unsigned long currentTime;
unsigned long loopTime;
const int pinA = 18;  // DT from encoder
const int pinB = 19;  // CLK from encoder

unsigned char Enc_A;
unsigned char Enc_B;
unsigned char Enc_A_prev = 0;

//gets called once at boot. Do all initialization that doesn't depend on network here
void userSetup()
{
  pinMode(pinA, INPUT_PULLUP);
  pinMode(pinB, INPUT_PULLUP);
  currentTime = millis();
  loopTime = currentTime;
}

//gets called every time WiFi is (re-)connected. Initialize own network interfaces here
void userConnected()
{

}

//loop. You can use "if (WLED_CONNECTED)" to check for successful connection
void userLoop()
{
   currentTime = millis();  // get the current elapsed time
  if(currentTime >= (loopTime + 2))  // 2ms since last check of encoder = 500Hz 
  {
    int Enc_A = digitalRead(pinA);  // Read encoder pins
    int Enc_B = digitalRead(pinB);   
    if((! Enc_A) && (Enc_A_prev)) { // A has gone from high to low
      if(Enc_B == HIGH) { // B is high so clockwise
        if(bri + fadeAmount <= 255) bri += fadeAmount;   // increase the brightness, dont go over 255
      
      } else if (Enc_B == LOW) { // B is low so counter-clockwise
        if(bri - fadeAmount >= 0) bri -= fadeAmount;   // decrease the brightness, dont go below 0          
      }   
    }   
      Enc_A_prev = Enc_A;     // Store value of A for next time    
      loopTime = currentTime;  // Updates loopTime
    
    //call for notifier -> 0: init 1: direct change 2: button 3: notification 4: nightlight 5: other (No notification)
    // 6: fx changed 7: hue 8: preset cycle 9: blynk 10: alexa
    colorUpdated(6);
  }
}
