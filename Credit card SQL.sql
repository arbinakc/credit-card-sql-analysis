CREATE DATABASE credit_card;

USE credit_card;

CREATE TABLE cardholders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    joined_on DATE NOT NULL
);

CREATE TABLE cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cardholder_id INT NOT NULL REFERENCES cardholders(id) ON DELETE CASCADE,
    last_four INT NOT NULL,
    network VARCHAR(20) NOT NULL,
    credit_limit DECIMAL(10, 2) NOT NULL,
    monthly_rate DECIMAL(6, 4) NOT NULL,
    late_fee_amount INT NOT NULL,
    minimum_rate DECIMAL(5, 4) NOT NULL,
    first_cycle_end DATE NOT NULL
);

CREATE TABLE statements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    card_id INT NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
    statement_no INT NOT NULL,
    period_end DATE NOT NULL,
    previous_balance DECIMAL(10, 2) NOT NULL,
    paid_in_full BOOLEAN NOT NULL,
    payments_received DECIMAL(10, 2) NOT NULL,
    carried_balance DECIMAL(10, 2) NOT NULL,
    purchases DECIMAL(10, 2) NOT NULL,
    balance_before_charges DECIMAL(10, 2) NOT NULL,
    interest_charged DECIMAL(10, 2) NOT NULL,
    payment_was_late BOOLEAN NOT NULL,
    late_fee DECIMAL(10, 2) NOT NULL,
    interest_and_fees DECIMAL(10, 2) NOT NULL,
    new_balance DECIMAL(10, 2) NOT NULL,
    minimum_due DECIMAL(10, 2) NOT NULL
);

SELECT * FROM cardholders;
SELECT * FROM cards;
SELECT * FROM statements;



-- 1) Retrieve all cardholders and sort them alphabetically by their last name.

SELECT first_name, last_name, email 
FROM cardholders 
ORDER BY last_name ASC;

-- 2) Identify all credit cards with a high credit limit exceeding $5,000.

SELECT id, cardholder_id, network, credit_limit 
FROM cards 
WHERE credit_limit > 5000;

-- 3) Retrieve statement details for statements where a payment was late and a late fee greater than zero was charged.

SELECT id, card_id, period_end, late_fee 
FROM statements 
WHERE payment_was_late = 1 AND late_fee > 0;

-- 4) Count how many total cardholders are registered in the cardholders database.

SELECT COUNT(*) AS total_cardholders 
FROM cardholders;

-- 5) Retrieve all credit cards where the network is exactly 'Visa'.

SELECT id, cardholder_id, credit_limit 
FROM cards 
WHERE network = 'Visa';

-- 6) Identify cards that have a credit limit between $2,000 and $5,000.

SELECT id, network, credit_limit 
FROM cards 
WHERE credit_limit BETWEEN 2000 AND 5000;

-- 7) Retrieve the first 3 rows from the cardholders table.

SELECT first_name, last_name 
FROM cardholders 
LIMIT 3;

-- 8) Identify all cardholders whose email addresses belong to the example.com domain.

SELECT first_name, last_name, email 
FROM cardholders 
WHERE email LIKE '%@example.com';

-- 9) Identify the top 5 highest credit limits across all cards in the system.

SELECT id, network, credit_limit 
FROM cards 
ORDER BY credit_limit DESC 
LIMIT 5;

-- 10) Calculate total cardholders and average credit limit.

SELECT COUNT(*) AS total_cardholders, 
(SELECT AVG(credit_limit) FROM cards) AS avg_credit_limit 
FROM cardholders;

-- 11) Identify the total number of credit cards issued for each card network.

SELECT network, COUNT(*) AS total_cards 
FROM cards 
GROUP BY network;

-- 12) Retrieve the cardholder's name, card network, and credit limit by linking cardholders to their respective cards.

SELECT 
    c.first_name, 
    c.last_name, 
    cr.network, 
    cr.credit_limit 
FROM cardholders c
JOIN cards cr ON c.id = cr.cardholder_id;

-- 13) Identify card networks that have more than 10 cards issued.

SELECT network, COUNT(*) AS card_count
FROM cards
GROUP BY network
HAVING COUNT(*) > 10;

-- 14) Classify each credit card as either 'High Limit' or 'Standard Limit' based on its credit limit amount.

SELECT id, credit_limit,
    CASE 
        WHEN credit_limit > 5000 THEN 'High Limit'
        ELSE 'Standard Limit'
    END AS limit_category
FROM cards;

-- 15) Retrieve cardholder names, card networks, statement numbers, and new balances by joining cardholders, cards, and statements together.

SELECT 
    ch.first_name, 
    ch.last_name, 
    cr.network, 
    s.statement_no, 
    s.new_balance 
FROM cardholders ch
JOIN cards cr ON ch.id = cr.cardholder_id
JOIN statements s ON cr.id = s.card_id;

-- 16) Identify all cards that have a credit limit higher than the overall average credit limit of all cards.

SELECT id, network, credit_limit 
FROM cards 
WHERE credit_limit > (SELECT AVG(credit_limit) FROM cards);

-- 17) Identify any cardholders who exist in the database but have never been issued a credit card.

SELECT ch.id, ch.first_name, ch.last_name
FROM cardholders ch
LEFT JOIN cards cr ON ch.id = cr.cardholder_id
WHERE cr.id IS NULL;


