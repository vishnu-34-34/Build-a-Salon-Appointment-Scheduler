#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo "Welcome to My Salon, how can I help you?"

echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"

read SERVICE_ID_SELECTED

SERVICE_EXISTS=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

while [[ -z $SERVICE_EXISTS ]]
do
  echo "I could not find that service. Please choose another service."
  echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
  read SERVICE_ID_SELECTED
  SERVICE_EXISTS=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
done

echo "What's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_NAME ]]
then
  echo "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  INSERTED_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME') RETURNING customer_id")
fi

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

echo "What time would you like your appointment?"
read SERVICE_TIME

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

$PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')"