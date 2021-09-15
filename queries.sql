/* First */
alter system flush buffer_cache;
alter system flush shared_pool;
                                                                                                                                   
set timing on;

SELECT * FROM "Order" ord
JOIN (SELECT * FROM Client client WHERE client.phone LIKE '%2%') cli ON cli.clientid=ord.clientId
JOIN (SELECT * FROM Review review 
        WHERE review.stars BETWEEN 0 AND 3
        AND review.title LIKE '%good%') rev ON rev.clientid=cli.clientid
/*JOIN specialoffer specoff ON rev.reviewdate BETWEEN specoff.startdate AND specoff.enddate 
JOIN (SELECT * FROM product product JOIN product_specialoffer prod_offer ON product.productId=prod_offer.productid) prod ON prod.specialofferId=specoff.offerId;
*/

JOIN (SELECT * FROM Product product WHERE product.style LIKE '%oxford%' AND product."size" BETWEEN 0 AND 9) prod ON prod.productid=rev.productid
JOIN (SELECT * FROM specialoffer specoff 
        JOIN product_specialoffer prodOff ON prodOff.specialofferId=specoff.offerId
        WHERE specoff.startdate >= '27.09.20 04:51:36,000000000'
        AND specoff.enddate <= '17.11.20 00:08:04,000000000') off ON off.productId=prod.productid;
                                                                                                                                            
set timing off;

/* Second */
alter system flush buffer_cache;
alter system flush shared_pool;
                                                                                                                                   
set timing on;

SELECT * FROM Payment payment
JOIN Address paymentAddress ON payment.addressid=paymentAddress.addressid
JOIN (SELECT adr.* FROM Address adr JOIN client cli ON cli.clientId=adr.clientId) clientAddress ON clientAddress.line1=paymentAddress.line1 
                                                                                                AND clientAddress.line2=paymentAddress.line2
                                                                                                AND clientAddress.city=paymentAddress.city
                                                                                                AND clientAddress.postalcode=paymentAddress.postalcode
JOIN Client client ON clientAddress.clientId=client.clientId
JOIN "Order" ord ON ord.clientId=client.clientid WHERE ord.total >= 2000;

set timing off;