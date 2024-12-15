import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../../database/providers/database_provider.dart';

class OrderItemsController {
  // GET /orderitems
  static Future<Response> getAll(Request request) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final results = await conn.query('''
        SELECT order_item, order_num, prod_id, quantity, size 
        FROM orderitems
      ''');

      final orderItems = results
          .map((row) => {
                'order_item': row[0],
                'order_num': row[1],
                'prod_id': row[2],
                'quantity': row[3],
                'size': row[4],
              })
          .toList();

      return Response.ok(
        jsonEncode(orderItems),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error fetching order items: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch order items'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // POST /orderitems
  static Future<Response> create(Request request) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (data['order_item'] == null || data['order_num'] == null || data['prod_id'] == null || data['quantity'] == null || data['size'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid data'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final conn = await DatabaseProvider.getConnection();
      await conn.query(
        '''
        INSERT INTO orderitems (order_item, order_num, prod_id, quantity, size) 
        VALUES (?, ?, ?, ?, ?)
        ''',
        [
          data['order_item'],
          data['order_num'],
          data['prod_id'],
          data['quantity'],
          data['size'],
        ],
      );

      return Response(
        201,
        body: jsonEncode({'message': 'Order item created successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error creating order item: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to create order item'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  // PUT /orderitems/<id>
  static Future<Response> update(Request request, String id) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload);

      if (data['quantity'] == null || data['size'] == null) {
        return Response(
          400,
          body: jsonEncode({'error': 'Invalid data'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final conn = await DatabaseProvider.getConnection();
      final result = await conn.query(
        '''
        UPDATE orderitems 
        SET quantity = ?, size = ? 
        WHERE order_item = ?
        ''',
        [
          data['quantity'],
          data['size'],
          id,
        ],
      );

      if (result.affectedRows == 0) {
        return Response(404, body: jsonEncode({'error': 'Order item not found'}));
      }

      return Response(
        200,
        body: jsonEncode({'message': 'Order item updated successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error updating order item: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to update order item'}),
      );
    }
  }

  // DELETE /orderitems/<id>
  static Future<Response> delete(Request request, String id) async {
    try {
      final conn = await DatabaseProvider.getConnection();
      final result = await conn.query('DELETE FROM orderitems WHERE order_item = ?', [id]);

      if (result.affectedRows == 0) {
        return Response(404, body: jsonEncode({'error': 'Order item not found'}));
      }

      return Response(
        200,
        body: jsonEncode({'message': 'Order item deleted successfully'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Error deleting order item: $e');
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to delete order item'}),
      );
    }
  }
}
