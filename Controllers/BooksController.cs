using Microsoft.AspNetCore.Mvc;
using MyBookApi.DTOs;
using MyBookApi.Mappers;
using MyBookApi.Services;

namespace MyBookApi.Controllers;

[ApiController]
[Route("api/books")]
public class BooksController : ControllerBase
{
    private readonly IBookService _bookService;

    public BooksController(IBookService bookService)
    {
        _bookService = bookService;
    }
    [HttpGet]
    public async Task<ActionResult<IEnumerable<BookResponseDTO>>> GetAll()
    {
        var books = await _bookService.GetAllAsync();
        var response = books.Select(b => b.ToResponseDTO());
        return Ok(response);
    }
}
